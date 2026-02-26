Class {
	#name : 'MiMooseNotebookPrinter',
	#superclass : 'INMicrodownNotebookPrinter',
	#instVars : [
		'nameSelector'
	],
	#category : 'MooseIDE-Export-Notebook',
	#package : 'MooseIDE-Export',
	#tag : 'Notebook'
}

{ #category : 'initialization' }
MiMooseNotebookPrinter >> initialize [

	super initialize.
	nameSelector := #mooseName
]

{ #category : 'accessing' }
MiMooseNotebookPrinter >> nameSelector [

	^ nameSelector
]

{ #category : 'printing' }
MiMooseNotebookPrinter >> printMooseName: anObject [

	nameSelector := #mooseName.
	self print: anObject
]

{ #category : 'printing' }
MiMooseNotebookPrinter >> printName: anObject [

	nameSelector := #name.
	self print: anObject
]

{ #category : 'printing' }
MiMooseNotebookPrinter >> stringForObject: anObject [

	^ anObject isMooseObject
		  ifTrue: [ self nameSelector value: anObject ]
		  ifFalse: [ super stringForObject: anObject ]
]
