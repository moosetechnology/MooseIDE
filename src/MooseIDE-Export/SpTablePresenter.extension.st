Extension { #name : #SpTablePresenter }

{ #category : #'*MooseIDE-Export' }
SpTablePresenter >> asCSVOn: aStream [

	| csvWriter |
	csvWriter := NeoCSVWriter on: aStream.
	self isShowingColumnHeaders ifTrue: [ 
		csvWriter writeHeader:
			(self columns collect: [ :column | column title ]) ].
	self columns do: [ :column | 
		csvWriter addField: [ :item | column readObject: item ] ].
	csvWriter nextPutAll: self items
]
