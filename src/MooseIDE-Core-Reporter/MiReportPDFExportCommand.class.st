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

	^ #mooseExportPDF
]

{ #category : #testing }
MiReportPDFExportCommand class >> defaultName [
	^ 'Export to PDF'
]

{ #category : #'as yet unclassified' }
MiReportPDFExportCommand >> exportReport: reporterBrowserModel [

	reporterBrowserModel exportReportToPDF
]
