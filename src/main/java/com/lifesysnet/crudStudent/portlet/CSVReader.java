package com.lifesysnet.crudStudent.portlet;

import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

public class CSVReader {
	private static final String csvDir = "D:\\student\\csv\\data-siswa.csv";
	
	public static void main (String[] args)  throws IOException  {
		try (
			Reader reader = Files.newBufferedReader(Paths.get(csvDir));
			CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT
					.withFirstRecordAsHeader()
					.withIgnoreHeaderCase()
					.withTrim());
		) {
			for (CSVRecord csvRecord : csvParser)
			{
				String stdId = csvRecord.get("stdId");
				String name = csvRecord.get("name");
				String kelas = csvRecord.get("kelas");
				String createdDate = csvRecord.get("created_date");
				String createdBy = csvRecord.get("created_by");
				String editedDate = csvRecord.get("edited_date");
				String editedBy = csvRecord.get("edited_by");
				String FileName = csvRecord.get("file_name");
				
				System.out.println("Record No "+ csvRecord.getRecordNumber());
				System.out.println("Name : "+name);
				System.out.println("Class : "+kelas);
				System.out.println("Created Date :"+createdDate);
				System.out.println("Created By : "+createdBy);
				System.out.println("Edited Date : "+editedDate);
				System.out.println("Edited By : "+editedBy);
				System.out.println("File Name : "+FileName);
			}
		}
	}
		
}
