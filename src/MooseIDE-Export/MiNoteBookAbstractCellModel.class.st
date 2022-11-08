"
I am the abstract class of cell model. I am used by the report model to store text in a cell.
And I am responsible to print the text I contain in a stream with a given context.
"
Class {
	#name : #MiNoteBookAbstractCellModel,
	#superclass : #Object,
	#instVars : [
		'text',
		'model'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #helpers }
MiNoteBookAbstractCellModel >> presenterClass [

	self subclassResponsibility
]

{ #category : #printing }
MiNoteBookAbstractCellModel >> printContentIn: aStream withContext: aContext [

	self subclassResponsibility
]

{ #category : #accessing }
MiNoteBookAbstractCellModel >> text [

	^ text
]

{ #category : #accessing }
MiNoteBookAbstractCellModel >> text: anObject [

	text := anObject
]
