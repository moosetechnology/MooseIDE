Class {
	#name : #MiNoteBookAbstractCellModel,
	#superclass : #Object,
	#instVars : [
		'text',
		'model'
	],
	#category : #'MooseIDE-Export-Report'
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
