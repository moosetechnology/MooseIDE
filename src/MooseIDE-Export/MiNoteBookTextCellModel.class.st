"
I am a microdown (text) cell model. I can print my text in a stream.
"
Class {
	#name : #MiNoteBookTextCellModel,
	#superclass : #MiNoteBookAbstractCellModel,
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #helpers }
MiNoteBookTextCellModel >> presenterClass [

	^ MiNoteBookTextCell
]

{ #category : #printing }
MiNoteBookTextCellModel >> printContentIn: aStream withContext: aContext [

	aStream nextPutAll: text
]
