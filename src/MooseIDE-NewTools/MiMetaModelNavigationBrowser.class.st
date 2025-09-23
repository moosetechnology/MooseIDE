Class {
	#name : 'MiMetaModelNavigationBrowser',
	#superclass : 'MiNavigationInspectionTab',
	#category : 'MooseIDE-NewTools-Inspector tabs',
	#package : 'MooseIDE-NewTools',
	#tag : 'Inspector tabs'
}

{ #category : 'private - display' }
MiMetaModelNavigationBrowser >> childrenFor: anEntity [

	^ {  }
]

{ #category : 'initialization' }
MiMetaModelNavigationBrowser >> initializeNavigationTreeTable [

	| sizeColumn |
	super initializeNavigationTreeTable.

	sizeColumn := SpStringTableColumn new
		              title: 'Size';
		              width: 50;
		              evaluated: [ :each |
			              each value isCollection
				              ifTrue: [ each value size printString ]
				              ifFalse: [ '' ] ].
	navigation columns: (navigation columns copyWithFirst: sizeColumn).

	navigation expandRoots
]

{ #category : 'private - display' }
MiMetaModelNavigationBrowser >> printEntry: anAssociation [

	^ anAssociation value size > 1
		  ifTrue: [ anAssociation key asEnglishPlural ]
		  ifFalse: [ anAssociation key ]
]
