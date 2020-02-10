"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	modelPresenter:		<Object>
	searchField:		<Object>


    Implementation Points
"
Class {
	#name : #MiModelRootBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'modelPresenter',
		'menu'
	],
	#category : #'Midas-ModelRootBrowser'
}

{ #category : #specs }
MiModelRootBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #menu withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #modelPresenter;
		yourself
]

{ #category : #specs }
MiModelRootBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #ModelRootBrowser)
		parent: self toolbarMetaName;
		label: 'Model root browser';
		action: [ self runMe ]
]

{ #category : #specs }
MiModelRootBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #accessing }
MiModelRootBrowser >> accept: anObject [
	^ false
]

{ #category : #initialization }
MiModelRootBrowser >> initializeList [
	modelPresenter := self newList.
	modelPresenter
		items: MooseModel root;
		display: [ :mooseModel | mooseModel name ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializePresenters [
	model := MiModelRootBrowserModel new.
	menu := self mainMenu.
	self initializeList.
	modelPresenter
		whenSelectionChangedDo: [ :selected | 
			model selected: selected selectedItem.
			self application globallySelect: selected selectedItem ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 600 @ 400
]

{ #category : #initialization }
MiModelRootBrowser >> mainMenu [
	| aMenu |
	aMenu := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Import mse';
						icon: (self iconNamed: #mooseImportMse);
						action: [ self inform: 'Import mse' ] ];
				addItem: [ :item | 
					item
						name: nil;
						description: 'Import St model';
						icon: (self iconNamed: #mooseImportSmalltalk);
						action: [ self inform: 'import smalltalk' ] ] ].
	^ aMenu
]

{ #category : #initialization }
MiModelRootBrowser >> modelPresenter [
	^ modelPresenter
]

{ #category : #initialization }
MiModelRootBrowser >> selectEntity: anEntity [
	(self accept: anEntity)
		ifFalse: [ ^ self ].
	modelPresenter selectItem: anEntity
	"self needRebuild: false.
	self buildWithSpec"
]

{ #category : #initialization }
MiModelRootBrowser >> selected [
	^ model selected
]

{ #category : #initialization }
MiModelRootBrowser >> setModelPresenterSelection [
	modelPresenter selectItem: modelPresenter roots first
]

{ #category : #initialization }
MiModelRootBrowser >> title [
	^ 'Model root Browser'
]
