"
** Moose IDE entrypoint **
Shows installed models and allows model installation.

- Accepted entities: Does not apply.
- Highlight: <TODO> Could highlight the model containing the received entity.
- Propagate: The selected model.

<TODO> Add features available in MoosePanel.
"
Class {
	#name : 'MiModelsBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'toolbar',
		'modelFilteringList'
	],
	#category : 'MooseIDE-Meta-ModelsBrowser',
	#package : 'MooseIDE-Meta',
	#tag : 'ModelsBrowser'
}

{ #category : 'keymaps' }
MiModelsBrowser class >> browserKey [

	^ $m
]

{ #category : 'commands' }
MiModelsBrowser class >> buildModelCommandsGroupWith: presenterInstance [

	^ CmCommandGroup forSpec beRoot
		  register: (MiInspectCommand forSpecContext: presenterInstance);
		  register: (MiPropagateCommand forSpecContext: presenterInstance);
		  register:
			  (MiModelExportCommand asCommandGroupWith: presenterInstance);
		  register:
			  (MiModelUtilityCommand asCommandGroupWith: presenterInstance)
]

{ #category : 'instance creation' }
MiModelsBrowser class >> instantiateAndOpen [

	^ super open
]

{ #category : 'testing' }
MiModelsBrowser class >> isModelImporter [
	^true
]

{ #category : 'world menu' }
MiModelsBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiModelsBrowser class >> menuIconName [

	^ #mooseNavigation
]

{ #category : 'world menu' }
MiModelsBrowser class >> menuItem [

	^ #ModelsBrowser
]

{ #category : 'world menu' }
MiModelsBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 2
]

{ #category : 'instance creation' }
MiModelsBrowser class >> newModel [

	^ MiModelsBrowserModel new
]

{ #category : 'instance creation' }
MiModelsBrowser class >> open [

	<script>
	^ MiApplication current openCurrentModelsBrowser
]

{ #category : 'specs' }
MiModelsBrowser class >> preferredExtent [

	^ 600 @ 400
]

{ #category : 'specs' }
MiModelsBrowser class >> title [

	^ 'Models browser'
]

{ #category : 'accessing' }
MiModelsBrowser >> allModels [

	^specModel entities
]

{ #category : 'window control' }
MiModelsBrowser >> browserClosed [

	super browserClosed.
	self application unregisterModelsBrowser
]

{ #category : 'testing' }
MiModelsBrowser >> canFollowEntity: anObject [
	^ false
]

{ #category : 'testing' }
MiModelsBrowser >> canTagEntities [
	"manipulates models, not entities"
	^false
]

{ #category : 'layout' }
MiModelsBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #toolbar expand: false;
		  add: #modelFilteringList;
		  yourself
]

{ #category : 'actions' }
MiModelsBrowser >> followEntity: anEntity [

	"Nothing to do"

	
]

{ #category : 'actions' }
MiModelsBrowser >> handleDropFile: aFileReference [

	self specModel modelImportIsAutomatic
		ifTrue: [
		self importFromFileUI handleDropFileAndImport: aFileReference ]
		ifFalse: [
				self importFromFileUI
					openDialog;
					handleDropFile: aFileReference ]
]

{ #category : 'accessing' }
MiModelsBrowser >> importFromFileUI [

	^ MiImportModelFromFileDialog on: self
]

{ #category : 'initialization' }
MiModelsBrowser >> initializeList [

	modelFilteringList := self newTable.
	self listOfMooseModels: specModel entities.

	modelFilteringList
		addColumn: (SpStringTableColumn new
				 title: 'Name';
				 sortFunction: #name ascending;
				 evaluated: [ :model | model name ] yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Language';
				 evaluated: [ :model |
					 model sourceLanguage
						 ifNil: [ 'unknown' ]
						 ifNotNil: [ :language | language name ] ];
				 beSortable;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Number of entities';
				 sortFunction: [ :model | model entities size ] ascending;
				 evaluated: [ :model | model entities size asString ];
				 beSortable;
				 yourself);
		contextMenu: [specModel selected ifNotNil: [  
		(self class buildModelCommandsGroupWith: self) asMenuPresenter ]];
		whenSelectionChangedDo: [ :selected |
		specModel selected: selected selectedItem ];
		activateOnDoubleClick;
		whenActivatedDo: [ self miInspect ]
]

{ #category : 'initialization' }
MiModelsBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeList.
	self selectAModelIfPossible
]

{ #category : 'initialization' }
MiModelsBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           fillWith:
			           (MiImportCommand asCommandGroupForSpecContext: self);
		           beIcons;
		           addItem: self refreshToolbarButton;
		           yourself
]

{ #category : 'updating' }
MiModelsBrowser >> listOfMooseModels: aList [

	modelFilteringList items: aList
]

{ #category : 'accessing' }
MiModelsBrowser >> miSelectedItem [

	^ specModel selected
]

{ #category : 'accessing' }
MiModelsBrowser >> miSelectedItemToPropagate [

	^ specModel selectedModel
]

{ #category : 'accessing - tests' }
MiModelsBrowser >> modelFilteringList [
	^ modelFilteringList
]

{ #category : 'initialization' }
MiModelsBrowser >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Refresh list';
		  action: [ self updateList ];
		  yourself
]

{ #category : 'initialization' }
MiModelsBrowser >> selectAModelIfPossible [

	specModel entities ifNotEmpty: [ :list |
		modelFilteringList selectItem: list first ]
]

{ #category : 'updating' }
MiModelsBrowser >> updateForNewModel: aModel [
	specModel updateForNewModel: aModel

]

{ #category : 'updating' }
MiModelsBrowser >> updateList [

	specModel updateMooseModelsList.
]
