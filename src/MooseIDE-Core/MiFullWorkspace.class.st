"
I am a workspace that can contain several browsers
"
Class {
	#name : #MiFullWorkspace,
	#superclass : #MiAbstractWorkspace,
	#instVars : [
		'left',
		'middle',
		'right',
		'downRight',
		'downMiddle',
		'downLeft'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #'world menu' }
MiFullWorkspace class >> helpMessage [

	^ (self comment lines copyUpTo: '') fold: [ :s1 :s2 | 
		  s1 , Character cr asString , s2 ]
]

{ #category : #'world menu' }
MiFullWorkspace class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self midasBrowserMenuLabel)
		order: 5;
		parent: #Moose;
		label: self title;
		icon: MooseIcons mooseIcon;
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'world menu' }
MiFullWorkspace class >> midasBrowserMenuLabel [

	^ 'Workspace'
]

{ #category : #'instance creation' }
MiFullWorkspace class >> open [

	<script: 'MiFullWorkspace open'>
	^ super open
]

{ #category : #accessing }
MiFullWorkspace class >> title [

	^ 'MooseIDE workspace'
]

{ #category : #specs }
MiFullWorkspace class >> windowSize [

	^ 800 @ 600
]

{ #category : #testing }
MiFullWorkspace >> canFollowEntity: anObject [

	"Accepts all entities, the contained browsers will decide for themselves if they accept or not"

	^ true
]

{ #category : #accessing }
MiFullWorkspace >> containedBrowsers [

	^ { 
		  left.
		  middle.
		  right.
		  downRight.
		  downMiddle.
		  downLeft }
		  select: [ :browserContainer | 
		  browserContainer installedPresenter notNil ]
		  thenCollect: [ :browserContainer | 
		  browserContainer installedPresenter ]
]

{ #category : #layout }
MiFullWorkspace >> defaultLayout [

	| positionBeforeRightPanels |
	positionBeforeRightPanels := 0.66. "Approximatey 2/3"

	^ SpBoxLayout newTopToBottom
		  add: (SpPanedLayout newTopToBottom
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #left;
								     add: #middle;
								     yourself);
						    positionOfSlider: positionBeforeRightPanels;
						    add: #right;
						    yourself);
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #downLeft;
								     add: #downMiddle;
								     yourself);
						    positionOfSlider: positionBeforeRightPanels;
						    add: #downRight;
						    yourself);
				   yourself);
		  yourself
]

{ #category : #initialization }
MiFullWorkspace >> initializePresenters [

	super initializePresenters.

	left := self newContainer.
	middle := self newContainer.
	right := self newContainer.
	downRight := self newContainer.
	downMiddle := self newContainer.
	downLeft := self newContainer
]

{ #category : #actions }
MiFullWorkspace >> install: aMiBrowser inContainer: aMiDropInContainer [

	super install: aMiBrowser inContainer: aMiDropInContainer.
	aMiBrowser receiveFromPrivateBus: privateBus logger mostRecentEntity
]

{ #category : #initialization }
MiFullWorkspace >> newContainer [

	^ super newContainer
		  borderWidth: 2;
		  acceptDrop: [ :transfer :destination | 
			  self install: transfer passenger inContainer: destination owner ];
		  yourself
]

{ #category : #removing }
MiFullWorkspace >> noteThatWidgetHasBeenReinstalled: aMiBrowser [

	
]

{ #category : #initialization }
MiFullWorkspace >> title [

	^ self class title
]

{ #category : #'private - updating' }
MiFullWorkspace >> windowSize [

	^ self class windowSize
]
