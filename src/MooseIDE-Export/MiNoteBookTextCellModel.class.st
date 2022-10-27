Class {
	#name : #MiNoteBookTextCellModel,
	#superclass : #MiNoteBookAbstractCellModel,
	#category : #'MooseIDE-Export-Report'
}

{ #category : #helpers }
MiNoteBookTextCellModel >> presenterClass [

	^ MiNoteBookTextCell
]

{ #category : #printing }
MiNoteBookTextCellModel >> printContentIn: aStream withContext: aContext [

	aStream nextPutAll: text
]
