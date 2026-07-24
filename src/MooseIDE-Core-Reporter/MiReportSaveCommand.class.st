"
I am a command to save the raw microdown report in MiModelReport

Not really an subclass of `MiReportExportCommand` but it is easier to add to the toolbar that way
"
Class {
	#name : 'MiReportSaveCommand',
	#superclass : 'MiReportExportCommand',
	#category : 'MooseIDE-Core-Reporter',
	#package : 'MooseIDE-Core-Reporter'
}

{ #category : 'default' }
MiReportSaveCommand class >> defaultDescription [
	^ 'Save this report in raw (microdown) format'
]

{ #category : 'default' }
MiReportSaveCommand class >> defaultIconName [

	^ #save
]

{ #category : 'default' }
MiReportSaveCommand class >> defaultName [
	^ 'Save raw report'
]

{ #category : 'export' }
MiReportSaveCommand >> exportReport: reporterBrowser [

	reporterBrowser saveRawReport
]
