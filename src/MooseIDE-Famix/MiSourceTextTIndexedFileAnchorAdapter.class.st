Class {
	#name : #MiSourceTextTIndexedFileAnchorAdapter,
	#superclass : #MiAbstractSourceTextAnchorAdapter,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextTIndexedFileAnchorAdapter class >> acceptedEntities [

	^{ FamixJavaClass . FamixJavaMethod }
]

{ #category : #api }
MiSourceTextTIndexedFileAnchorAdapter >> intervalForEntity: anEntity [

	| offset |
	(super intervalForEntity: anEntity)
		ifNotNil: [ :interval | ^interval ].

	offset := displayedEntityInterval key sourceAnchor.

	offset ifNil: [ ^nil ].
	anEntity sourceAnchor ifNil: [  ^nil ].

	^Interval
		from: (anEntity sourceAnchor startPos - offset startPos + 1)
		to: (anEntity sourceAnchor endPos - offset startPos + 1)

]
