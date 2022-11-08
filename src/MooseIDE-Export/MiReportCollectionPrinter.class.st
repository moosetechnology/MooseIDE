"
I am a printer, used to print collections in a stream.
"
Class {
	#name : #MiReportCollectionPrinter,
	#superclass : #MiAbstractReportPrinter,
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #printing }
MiReportCollectionPrinter >> print: aCollection [

	aCollection do: [ :e |
		micBuilder unorderedListDuring: [ micBuilder item: [micBuilder raw: e mooseName]].	
	]
]

{ #category : #printing }
MiReportCollectionPrinter >> print: aCollection with: aBlock [

	self sort: aCollection with: aBlock.
	aCollection do: [ :e | 
		e isAssociation
			ifTrue: [ self printAssoc: e with: aBlock ]
			ifFalse: [ self printElement: e with: aBlock ] ]
]

{ #category : #printing }
MiReportCollectionPrinter >> printAssoc: anAssoc with: aBlock [

	micBuilder unorderedListDuring: [ 
		micBuilder item: [ micBuilder raw: (aBlock value: anAssoc key) ].
		micBuilder unorderedListDuring: [ 
			anAssoc value do: [ :e | 
				micBuilder item: [ micBuilder raw: (aBlock value: e) ] ] ] ]
]

{ #category : #printing }
MiReportCollectionPrinter >> printElement: aMooseObject with: aBlock [

	micBuilder unorderedListDuring: [ micBuilder item: [micBuilder raw: (aBlock value: aMooseObject)]]
]

{ #category : #printing }
MiReportCollectionPrinter >> printMooseName: aCollection [
	
	self print: aCollection with: [ :e | 
		e isMooseObject
			ifTrue: [ e mooseName ]
			ifFalse: [ e ] ]
]

{ #category : #printing }
MiReportCollectionPrinter >> printName: aCollection [

	self print: aCollection with: [ :e | 
		e isMooseObject
			ifTrue: [ e name ]
			ifFalse: [ e ] ]
]

{ #category : #printing }
MiReportCollectionPrinter >> sort: aCollection with: aBlock [

	| val |
	val := [ :a | a ].
	(aCollection allSatisfy: [ :e | e isAssociation ]) ifTrue: [ 
		val := [ :a | a key ] ].
	aCollection sort: [ :a :b | 
		(aBlock value: (val value: a)) < (aBlock value: (val value: b)) ]
]
