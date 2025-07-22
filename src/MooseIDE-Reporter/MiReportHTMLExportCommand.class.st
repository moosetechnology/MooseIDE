Class {
	#name : 'MiReportHTMLExportCommand',
	#superclass : 'MiReportExportCommand',
	#category : 'MooseIDE-Reporter',
	#package : 'MooseIDE-Reporter'
}

{ #category : 'testing' }
MiReportHTMLExportCommand class >> defaultDescription [
	^ 'Export this report to HTML'
]

{ #category : 'testing' }
MiReportHTMLExportCommand class >> defaultIconName [

	^ #save
]

{ #category : 'testing' }
MiReportHTMLExportCommand class >> defaultName [
	^ 'Export to HTML'
]

{ #category : 'export' }
MiReportHTMLExportCommand >> exportReport: reporterBrowserModel [

	reporterBrowserModel exportReportToHTML
]
