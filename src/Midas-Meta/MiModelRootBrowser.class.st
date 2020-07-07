"
** Midas entrypoint **
Shows installed models and allows model installation.

- Follow:
Nothing to do.

- Highlight:
<TODO> Could highlight the model containing the received entity.

- Propagate:
The selected model.

<TODO> Add features available in MoosePanel.
"
Class {
	#name : #MiModelRootBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'modelPresenter'
	],
	#category : #'Midas-Meta-ModelRootBrowser'
}

{ #category : #'world menu' }
MiModelRootBrowser class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [
	super
		buildCommandsGroupWith: presenterInstance
		forRoot: rootCommandGroup.
	rootCommandGroup
		register: (MiSetRootFolderCommand forSpecContext: presenterInstance)
]

{ #category : #specs }
MiModelRootBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #menu withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #modelPresenter;
		yourself
]

{ #category : #specs }
MiModelRootBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #ModelRootBrowser)
		parent: self toolbarMetaName;
		label: self title;
		icon: (self iconNamed: #mooseNavigation);
		order: 1.0;
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> newModel [
	^ MiModelRootBrowserModel new
]

{ #category : #specs }
MiModelRootBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #initialization }
MiModelRootBrowser class >> title [
	^ 'Model root'
]

{ #category : #specs }
MiModelRootBrowser class >> windowSize [
	^ 600 @ 400
]

{ #category : #testing }
MiModelRootBrowser >> accept: anObject [
	^ false
]

{ #category : #actions }
MiModelRootBrowser >> followAction [
	^ self
]

{ #category : #menu }
MiModelRootBrowser >> importMSEMenuItem: item [
	^ item
		description: 'Import mse';
		icon: (self iconNamed: #mooseImportMse);
		action: [ MiImportModel new openModalWithSpec.
			modelPresenter updateList ]
]

{ #category : #menu }
MiModelRootBrowser >> importStMenuItem: item [
	^ item
		description: 'Import St model';
		icon: (self iconNamed: #mooseImportSmalltalk);
		action: [ (MooseImportFromSmalltalkImageWizard new
				open;
				mooseModel) ifNotNil: [ :mooseModel | modelPresenter updateList ] ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializeList [
	modelPresenter := self newList
		items: MooseModel root;
		display: [ :mooseModel | mooseModel name ];
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		whenSelectionChangedDo: [ :selected | 
			model selected: selected selectedItem.
			self bus globallySelect: selected selectedItem ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializeMenu [
	menu := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | self importMSEMenuItem: item ];
				addItem: [ :item | self importStMenuItem: item ] ];
		addItem: [ :item | self refreshMenuItem: item ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializePresenters [
	super initializePresenters.
	self initializeMenu.
	self initializeList
]

{ #category : #accessing }
MiModelRootBrowser >> miSelectedItem [
	^ modelPresenter selection selectedItem
]

{ #category : #accessing }
MiModelRootBrowser >> modelPresenter [
	^ modelPresenter
]

{ #category : #menu }
MiModelRootBrowser >> refreshMenuItem: item [
	^ item
		description: 'Refresh list';
		icon: (self iconNamed: #smallUpdate);
		action: [ modelPresenter updateList ]
]

{ #category : #accessing }
MiModelRootBrowser >> selected [
	^ model selected
]

{ #category : #accessing }
MiModelRootBrowser >> selectedObject [
	^ modelPresenter selection selectedItem
]
