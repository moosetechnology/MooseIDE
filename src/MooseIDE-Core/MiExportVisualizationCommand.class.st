Class {
	#name : #MiExportVisualizationCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiExportVisualizationCommand class >> defaultDescription [

	^ 'Export this visulization'
]

{ #category : #default }
MiExportVisualizationCommand class >> defaultIconName [

	^ #smallExport
]

{ #category : #default }
MiExportVisualizationCommand class >> defaultName [

	^ 'Export'
]

{ #category : #executing }
MiExportVisualizationCommand >> execute [

	self context exportVisualization
]
