Class {
	#name : #MiReportPDFExportCommand,
	#superclass : #MiReportExportCommand,
	#category : #'MooseIDE-Core-Reporter'
}

{ #category : #testing }
MiReportPDFExportCommand class >> defaultDescription [
	^ 'Export this report to PDF'
]

{ #category : #testing }
MiReportPDFExportCommand class >> defaultIconName [

	^ #save
]

{ #category : #testing }
MiReportPDFExportCommand class >> defaultName [
	^ 'Export to PDF'
]

{ #category : #export }
MiReportPDFExportCommand >> exportReport: reporterBrowser [

	reporterBrowser exportReportToPDF
]
