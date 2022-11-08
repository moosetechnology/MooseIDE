"
I am a code cell model. I can execute a code with a given context.
"
Class {
	#name : #MiNoteBookCodeCellModel,
	#superclass : #MiNoteBookAbstractCellModel,
	#category : #'MooseIDE-Export-Notebook'
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
