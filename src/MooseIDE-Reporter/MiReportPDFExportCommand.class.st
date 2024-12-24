Class {
	#name : #MiReportPDFExportCommand,
	#superclass : #MiReportExportCommand,
	#category : #'MooseIDE-Reporter'
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

{ #category : #'as yet unclassified' }
MiReportPDFExportCommand >> exportReport: reporterBrowserModel [

	reporterBrowserModel exportReportToPDF
]
