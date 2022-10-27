Class {
	#name : #MiNoteBookCodeCellModel,
	#superclass : #MiNoteBookAbstractCellModel,
	#category : #'MooseIDE-Export-Report'
}

{ #category : #helpers }
MiNoteBookCodeCellModel >> presenterClass [

	^ MiNoteBookCodeCell
]

{ #category : #printing }
MiNoteBookCodeCellModel >> printContentIn: aStream withContext: aContext [

	aContext bindings at: 'stream' put: aStream.
	aContext bindings at: 'printer' put: (MiReportCollectionPrinter new
			 stream: aStream;
			 yourself).
	self class compiler
		compilationContext: aContext;
		source: text;
		evaluate
]
