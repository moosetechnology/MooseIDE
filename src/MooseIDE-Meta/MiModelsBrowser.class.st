"
** Moose IDE entrypoint **
Shows installed models and allows model installation.

- Accepted entities: Does not apply.
- Highlight: <TODO> Could highlight the model containing the received entity.
- Propagate: The selected model.

<TODO> Add features available in MoosePanel.
"
Class {
	#name : #MiModelsBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'modelFilteringList'
	],
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #keymaps }
MiModelsBrowser class >> browserKey [

	^ $m
]

{ #category : #commands }
MiModelsBrowser class >> buildModelCommandsGroupWith: presenterInstance [

	^ CmCommandGroup forSpec beRoot
		  register: (MiInspectCommand forSpecContext: presenterInstance);
		  register: (MiPropagateCommand forSpecContext: presenterInstance);
		  register:
			  (MiModelExportCommand asCommandGroupWith: presenterInstance);
		  register:
			  (MiModelUtilityCommand asCommandGroupWith: presenterInstance)
]

{ #category : #layout }
MiModelsBrowser class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #toolbar
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  add: #modelFilteringList;
		  yourself
]

{ #category : #testing }
MiModelsBrowser class >> isModelImporter [
	^true
]

{ #category : #'world menu' }
MiModelsBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiModelsBrowser class >> menuIconName [

	^ #mooseNavigation
]

{ #category : #'world menu' }
MiModelsBrowser class >> menuItem [

	^ #ModelsBrowser
]

{ #category : #'world menu' }
MiModelsBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 2
]

{ #category : #'instance creation' }
MiModelsBrowser class >> newModel [

	^ MiModelsBrowserModel new
]

{ #category : #'instance creation' }
MiModelsBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiModelsBrowser class >> title [

	^ 'Models browser'
]

{ #category : #specs }
MiModelsBrowser class >> windowSize [

	^ 600 @ 400
]

{ #category : #testing }
MiModelsBrowser >> canFollowEntity: anObject [
	^ false
]

{ #category : #testing }
MiModelsBrowser >> canTagEntities [
	"manipulates models, not entities"
	^false
]

{ #category : #actions }
MiModelsBrowser >> followEntity: anEntity [

	"Nothing to do"

	
]

{ #category : #actions }
MiModelsBrowser >> handleDropFile: aFileReference [
	
	self model autoImportSetting 
		ifTrue: [self importFromFileUI handleDropFileAndImport: aFileReference.  ]
		ifFalse: [self importFromFileUI handleDropFile: aFileReference].
	
	
	

]

{ #category : #'private testing' }
MiModelsBrowser >> handleDropFileAndImport: aFileReference [

	self importFromFileUI handleDropFileAndImport: aFileReference.

]

{ #category : #testing }
MiModelsBrowser >> hasSettings [
	^ true
]

{ #category : #accessing }
MiModelsBrowser >> importFromFileUI [
	^MiImportFromFileCommand new execute presenter
]

{ #category : #initialization }
MiModelsBrowser >> initializeList [

	modelFilteringList := self newFilteringList.
	self listOfMooseModels: specModel entities.

	modelFilteringList display: [ :mooseModel | mooseModel name ].
	modelFilteringList listPresenter contextMenu: [ (self class buildModelCommandsGroupWith: self) asMenuPresenter ].
	modelFilteringList whenSelectionChangedDo: [ :selected | specModel selected: selected selectedItem ]
]

{ #category : #initialization }
MiModelsBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeList
]

{ #category : #initialization }
MiModelsBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           fillWith: (MiImportCommand asCommandGroupForSpecContext: self);
		           beIcons;
		           addItem: self refreshToolbarButton;
		           yourself
]

{ #category : #updating }
MiModelsBrowser >> listOfMooseModels: aList [

	modelFilteringList items: aList.
	
]

{ #category : #accessing }
MiModelsBrowser >> miSelectedItem [

	^ specModel selectedModel
]

{ #category : #accessing }
MiModelsBrowser >> miSelectedModel [

	"similar to #miSelectedItem but ignore the setting #filterStubsSetting"

	^ specModel selected
]

{ #category : #'accessing - tests' }
MiModelsBrowser >> modelFilteringList [
	^ modelFilteringList
]

{ #category : #initialization }
MiModelsBrowser >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Refresh list';
		  action: [ self updateList ];
		  yourself
]

{ #category : #'accessing - tests' }
MiModelsBrowser >> settingsItem [
	^ specModel settings
]

{ #category : #updating }
MiModelsBrowser >> updateForNewModel: aModel [
	specModel updateForNewModel: aModel

]

{ #category : #updating }
MiModelsBrowser >> updateList [

	specModel updateMooseModelsList.
]
