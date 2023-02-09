"
** Moose IDE entrypoint **
Shows installed models and allows model installation.

- Follow: Nothing to do.
- Highlight: <TODO> Could highlight the model containing the received entity.
- Propagate: The selected model.

<TODO> Add features available in MoosePanel.
"
Class {
	#name : #MiModelRootBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'modelFilteringList',
		'blockWhenSelection'
	],
	#category : #'MooseIDE-Meta-ModelRootBrowser'
}

{ #category : #menu }
MiModelRootBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aRootMenu defaultSubMenu: aSubMenu [

	self addToMiBrowsersMenu: aRootMenu
]

{ #category : #commands }
MiModelRootBrowser class >> buildModelCommandsGroupWith: presenterInstance [

	^ CmCommandGroup forSpec beRoot
		  register: (MiInspectCommand forSpecContext: presenterInstance);
		  register: (MiPropagateCommand forSpecContext: presenterInstance);
		  register:
			  (MiModelExportCommand asCommandGroupWith: presenterInstance);
		  register:
			  (MiModelUtilityCommand asCommandGroupWith: presenterInstance)
]

{ #category : #layout }
MiModelRootBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #toolbar
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  add: #modelFilteringList;
		  yourself
]

{ #category : #testing }
MiModelRootBrowser class >> isModelImporter [
	^true
]

{ #category : #'world menu' }
MiModelRootBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiModelRootBrowser class >> menuIconName [

	^ #mooseNavigation
]

{ #category : #'world menu' }
MiModelRootBrowser class >> menuItem [

	^ #ModelRootBrowser
]

{ #category : #'world menu' }
MiModelRootBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 2
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> newModel [

	^ MiModelRootBrowserModel new
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiModelRootBrowser class >> title [

	^ 'Models browser'
]

{ #category : #specs }
MiModelRootBrowser class >> windowSize [

	^ 600 @ 400
]

{ #category : #testing }
MiModelRootBrowser >> canFollowEntity: anObject [
	^ false
]

{ #category : #testing }
MiModelRootBrowser >> canPropagate [

	^model canPropagate
]

{ #category : #actions }
MiModelRootBrowser >> followEntity: anEntity [

	"Nothing to do"

	
]

{ #category : #actions }
MiModelRootBrowser >> handleDropFile: aFileReference [
	self importFromFileUI handleDropFile: aFileReference.

]

{ #category : #testing }
MiModelRootBrowser >> hasSettings [
	^ true
]

{ #category : #accessing }
MiModelRootBrowser >> importFromFileUI [
	^MiImportFromFileCommand new execute presenter
]

{ #category : #initialization }
MiModelRootBrowser >> initializeList [

	modelFilteringList := self newFilteringList.
	self listOfMooseModels: model mooseModelsList.

	modelFilteringList display: [ :mooseModel | mooseModel name ].

	modelFilteringList listPresenter contextMenu: [ 
		(self class buildModelCommandsGroupWith: self) asMenuPresenter ].
	blockWhenSelection := [ :selected | 
	                      model selected: selected selectedItem ].
	modelFilteringList whenSelectionChangedDo: blockWhenSelection
]

{ #category : #initialization }
MiModelRootBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeList
]

{ #category : #initialization }
MiModelRootBrowser >> initializeToolbar [

	toolbar := (MiImportCommand asCommandGroupForSpecContext: self)
		           asToolbarPresenter beIcons.
	toolbar addItem: self refreshToolbarButton
]

{ #category : #updating }
MiModelRootBrowser >> listOfMooseModels: aList [

	modelFilteringList items: aList.
	
]

{ #category : #accessing }
MiModelRootBrowser >> miSelectedItem [

	^model selected
]

{ #category : #accessing }
MiModelRootBrowser >> miSelectedModel [
	"similar to #miSelectedItem but ignore the setting #filterStubsSetting"

	^model selectedModel
]

{ #category : #'accessing - tests' }
MiModelRootBrowser >> modelFilteringList [
	^ modelFilteringList
]

{ #category : #initialization }
MiModelRootBrowser >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Refresh list';
		  action: [ self updateList ];
		  yourself
]

{ #category : #actions }
MiModelRootBrowser >> settings [

	^model openSettings
]

{ #category : #'accessing - tests' }
MiModelRootBrowser >> settingsItem [
	^ model settings
]

{ #category : #updating }
MiModelRootBrowser >> updateForNewModel: aModel [
	model updateForNewModel: aModel

]

{ #category : #updating }
MiModelRootBrowser >> updateList [

	model updateMooseModelsList.
]
