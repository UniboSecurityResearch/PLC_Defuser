import os
import xml.etree.ElementTree as ET
import pandas as pd
from pathlib import Path

# Pandas Display Configuration
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000) # Increased to avoid ugly line wrapping

def count_rungs_and_lines(xml_path):
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
    except ET.ParseError:
        return 0, 0, 0 # Skip corrupted files

    NS = {'po': 'http://www.plcopen.org/xml/tc6_0201',
          'xhtml': 'http://www.w3.org/1999/xhtml'}

    # Count Rungs (Ladder Logic)
    ld_sections = root.findall('.//po:LD', namespaces=NS)
    rung_count = 0
    for ld in ld_sections:
        for rail in ld.findall('.//po:leftPowerRail', namespaces=NS):
            outs = rail.findall('.//po:connectionPointOut', namespaces=NS)
            rung_count += len(outs)
    
    # Count ST lines (Structured Text)
    st_sections = root.findall('.//po:ST', namespaces=NS)
    st_line_count = 0
    for st in st_sections:
        lines = st.findall('.//xhtml:p', namespaces=NS)
        for line in lines:
            # FIX: Handle cases where line.text is None (empty tag)
            text_content = line.text or ""
            # Optional: filter empty lines with "if line.strip()"
            st_line_count += len(text_content.splitlines())
    
    # Count instructions (physical lines in the file)
    try:
        with open(xml_path, 'r', encoding='utf-8') as f:
            instr_count = sum(1 for _ in f)
    except Exception:
        instr_count = 0
        
    return rung_count, st_line_count, instr_count

def gather_stats(directory):
    records = []
    # Convert to Path object for safe handling
    base_dir = Path(directory)
    
    if not base_dir.exists():
        print(f"Warning: Directory not found -> {directory}")
        return pd.DataFrame()

    for file_path in base_dir.rglob('*.xml'): # rglob finds all .xml files recursively
        size_kb = file_path.stat().st_size / 1024
        rungs, st, instr = count_rungs_and_lines(file_path)
        records.append({
            'size_kb': size_kb,
            'rungs': rungs,
            'st_lines': st,
            'instructions': instr
        })
    return pd.DataFrame(records)

def summarize_stats(df):
    if df.empty:
        return pd.DataFrame()

    max_kb = df['size_kb'].max()
    # Bin definition
    base_bins  = [0, 40, 45, 50, 55, 60, 65, 70, 75, 80, 100]
    base_labels = ['0–40','41–45','46–50','51–55','56–60','61–65','66–70','71–75','76–80','81–100']

    # Dynamic extension if there are giant files
    if max_kb > 100:
        bins  = base_bins + [max_kb + 1]
        labels = base_labels + ['100+']
    else:
        bins  = base_bins
        labels = base_labels

    # Category creation
    df['size_bin'] = pd.cut(df['size_kb'], bins=bins, labels=labels, right=False)
    
    # Aggregation
    # observed=False forces Pandas to show empty bins (NaN) as well
    summary = df.groupby('size_bin', observed=False).agg(
        num_files=('size_kb', 'count'),
        rung_min=('rungs', 'min'),
        rung_max=('rungs', 'max'),
        rung_total=('rungs', 'sum'),
        rung_avg=('rungs', 'mean'),
        st_min=('st_lines', 'min'),
        st_max=('st_lines', 'max'),
        st_total=('st_lines', 'sum'),
        st_avg=('st_lines', 'mean'),
        instr_min=('instructions', 'min'),
        instr_max=('instructions', 'max'),
        instr_total=('instructions', 'sum'),
        instr_avg=('instructions', 'mean'),
    ).reset_index()
    
    return summary

if __name__ == '__main__':
    # Relative paths (ensure you are in the correct folder when running the script)
    dirs_to_check = {
        'Legitimate': './SWAT/legitimate/',
        'Malicious': './SWAT/malicious/'
    }

    for label, path in dirs_to_check.items():
        print(f"\n{'='*40}")
        print(f"Processing {label} files from: {path}")
        print(f"{'='*40}")
        
        df = gather_stats(path)
        summary = summarize_stats(df)
        
        if not summary.empty:
            # summary = summary.fillna(0) 
            print(summary.to_string()) # to_string forces full output
        else:
            print("No files found or dataframe is empty.")