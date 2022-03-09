"
I define many SpDropInContainer tiles where drop whatever widget that inherits from MiDraggableAbstractWidget.

"
Class {
	#name : #MiDropIntoBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'status',
		'left',
		'middle',
		'right',
		'downRight',
		'downMiddle',
		'downLeft',
		'miSelectedItem'
	],
	#classInstVars : [
		'horizontalScrollBar'
	],
	#category : #'MooseIDE-Durden'
}

{ #category : #specs }
MiDropIntoBrowser class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #toolbar height: self toolbarHeight;
		  add: (SpPanedLayout newTopToBottom
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #left;
								     add: #middle);
						    add: #right;
						    yourself);
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #downLeft;
								     add: #downMiddle);
						    add: #downRight;
						    yourself));
		  add: #status height: self toolbarHeight
]

{ #category : #specs }
MiDropIntoBrowser class >> menuCommandOn: aBuilder [ 
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #dropInMooseBrowser)
		parent: #Moose;
		label: (self title);
		help: (self helpMessage); 
		action: [ self open ]
]

{ #category : #specs }
MiDropIntoBrowser class >> open [

	<script>
	self new open
]

{ #category : #specs }
MiDropIntoBrowser class >> title [ 
	 ^ 'Tyler Browser'
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> allPresenters [

	^ { #left. #middle. #right. #downRight. #downMiddle. #downLeft } 
		  flatCollect: [ :m | (self instVarNamed: m) installedPresenters ]
]

{ #category : #'as yet unclassified' }
MiDropIntoBrowser >> allPresentersBut: anAlceReferenceWidget [

	^ self allPresenters asOrderedCollection
		  remove: anAlceReferenceWidget ifAbsent: [  ];
		  yourself
]

{ #category : #initialization }
MiDropIntoBrowser >> application [
	 ^ application
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> followAction [

	self allPresenters do: [ :p | p followAction ]
]

{ #category : #initialization }
MiDropIntoBrowser >> initializePresenters [

	toolbar := self newToolbar.
	status := self newStatusBar.
	left := self newContainer.
	middle := self newContainer.
	right := self newContainer.
	downRight := self newContainer.
	downMiddle := self newContainer.
	downLeft := self newContainer
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> installTransfer: aTransfer into: destination [

	(destination install: aTransfer passenger)
		dragTilte;
		browser: self;
		whenClose: [ :a | destination noteThatWidgetHasBeenClosed:  a ].
	aTransfer passenger hasBeenReinstalled
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> miSelectedItem [

	^ miSelectedItem
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> newContainer [

	^ ((self instantiate: SpSingleDropInContainer)
		   borderWidth: 2;
		   dropEnabled: true;
		   wantsDrop: [ :transfer :destination | 
			   self shouldAcceptTransfer: transfer into: destination ];
		   acceptDrop: [ :transfer :destination | 
			   self installTransfer: transfer into: destination ]) yourself
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> propagate: aWidget [

	| newSelection |
	miSelectedItem := aWidget miSelectedItem.
	newSelection := miSelectedItem.
	newSelection ifNil: [ ^ self ].
	(self allPresentersBut: aWidget) do: [ :w | 
		w receiveEntity: newSelection.
		miSelectedItem := newSelection ].

	self propagate.
	miSelectedItem := nil
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> receiveEntity: anEntity [

	self allPresenters do: [ :p | p receiveEntity: anEntity ]
]

{ #category : #'instance creation' }
MiDropIntoBrowser >> shouldAcceptTransfer: aTransfer into: aDestination [

	(aTransfer isKindOf: SpTransferMorph) ifFalse: [ ^ false ].
	^ aTransfer passenger canBeAdaptedToDropInto: aDestination
]
