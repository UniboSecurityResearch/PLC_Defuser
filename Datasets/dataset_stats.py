import os
import xml.etree.ElementTree as ET
import pandas as pd
from pathlib import Path

# Remove any existing DataFrame display limits
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)

def count_rungs_and_lines(xml_path):
    # Parse XML
    tree = ET.parse(xml_path)
    root = tree.getroot()
    # Count <connectionPointOut> under each <leftPowerRail>

    NS = {'po': 'http://www.plcopen.org/xml/tc6_0201',
          'xhtml': 'http://www.w3.org/1999/xhtml'}

    ld_sections = root.findall('.//po:LD', namespaces=NS)
    rung_count = 0
    for ld in ld_sections:
        # For each leftPowerRail within this LD section
        for rail in ld.findall('.//po:leftPowerRail', namespaces=NS):
            # Count its nested connectionPointOut tags
            outs = rail.findall('.//po:connectionPointOut', namespaces=NS)
            rung_count += len(outs)
    
    st_sections = root.findall('.//po:ST', namespaces=NS)
    st_line_count = 0
    # Len of lines in ST sections
    for st in st_sections:
        # Count the number of lines in the ST section
        lines = st.findall('.//xhtml:p', namespaces=NS)
        for line in lines:
            st_line_count += len(line.text.splitlines())
    
    # Instruction count = number of lines in the file
    with open(xml_path, 'r', encoding='utf-8') as f:
        instr_count = sum(1 for _ in f)
    return rung_count, st_line_count, instr_count

def gather_stats(directory):
    records = []
    for dirpath, _, filenames in os.walk(directory):
        for fname in filenames:
            if not fname.lower().endswith('.xml'):
                continue
            file_path = Path(dirpath) / fname
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
    # Define size bins
    max_kb = df['size_kb'].max()
    base_bins  = [0, 40, 45, 50, 55, 60, 65, 70, 75, 80, 100]
    base_labels = ['0–40','41–45','46–50','51–55','56–60','61–65','66–70','71–75','76–80','81–100']

    if max_kb > 100:
        bins  = base_bins + [max_kb + 1]
        labels = base_labels + ['100+']
    else:
        bins  = base_bins
        labels = base_labels

    df['size_bin'] = pd.cut(df['size_kb'], bins=bins, labels=labels, right=False)
    
    # Aggregate statistics
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
    # **** Update this path to a specific directory ****
    # Legitimate PLC files    
    directory = './SWAT/legitimate/'
    
    df = gather_stats(directory)
    summary = summarize_stats(df)
    
    # Display or save
    print("Summary of legitimate XML file statistics:")
    print(summary)

    # Malicious PLC files
    directory = './SWAT/malicious/'
    
    df = gather_stats(directory)
    summary = summarize_stats(df)
    
    # Display or save
    print("Summary of malicious XML file statistics:")
    print(summary)
