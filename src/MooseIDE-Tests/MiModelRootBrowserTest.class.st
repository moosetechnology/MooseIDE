Class {
	#name : #MiModelRootBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'savedRoot'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiModelRootBrowserTest >> browserClass [
	^ MiModelRootBrowser
]

{ #category : #running }
MiModelRootBrowserTest >> setUp [

	savedRoot := MooseModelRoot installedRoot.
	MooseModelRoot resetRoot.
	super setUp
]

{ #category : #running }
MiModelRootBrowserTest >> tearDown [

	MooseModelRoot installRoot: savedRoot.
	super tearDown
]

{ #category : #tests }
MiModelRootBrowserTest >> testActivateActionButtons [

	| newModel |
	{ 
		MiInspectCommand.
		MiPropagateCommand } do: [ :cmdClass | 
		self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	newModel := MooseModel new.
	newModel install.
	browser containedBrowser updateForNewModel: newModel.

	{ 
		MiInspectCommand.
		MiPropagateCommand.
		MiDragWindowCommand } do: [ :cmdClass | 
		self assert: (self actionButton: cmdClass) isEnabled ]
]

{ #category : #tests }
MiModelRootBrowserTest >> testFilterStubsSettingsWithoutStub [

	| newModel |
	self assert: browser containedBrowser miSelectedItem isNil.

	newModel := FamixStModel new.
	newModel addAll: { 
			((FamixStClass named: 'Class1')
				 isStub: true;
				 yourself).
			((FamixStClass named: 'Class2')
				 isStub: false;
				 yourself) }.

	MooseModel root add: newModel.
	browser containedBrowser updateForNewModel: newModel.

	self assert: browser containedBrowser miSelectedItem size equals: 1.
	self
		assert: browser containedBrowser miSelectedItem anyOne name
		equals: 'Class2'.

	browser containedBrowser settingsItem
		setItem: #filterStubsSetting
		value: false.
	browser containedBrowser updateForNewModel: newModel.
	self assert: browser containedBrowser miSelectedItem size equals: 2
]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItem [

	| newModel |
	self
		should: [ browser miSelectedItem ]
		raise: MiNoSelectedElementToPropagateException.

	newModel := MooseModel new.
	newModel install.
	browser containedBrowser updateForNewModel: newModel.

	self
		shouldnt: [ browser miSelectedItem ]
		raise: MiNoSelectedElementToPropagateException.
	self deny: browser miSelectedItem isNil
]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItemWithoutStub [

	| newModel |
	self assert: browser containedBrowser miSelectedItem isNil.

	newModel := FamixStModel new.
	newModel addAll: { 
			((FamixStClass named: 'Class1')
				 isStub: true;
				 yourself).
			((FamixStClass named: 'Class2')
				 isStub: false;
				 yourself) }.


	MooseModel root add: newModel.
	browser containedBrowser updateForNewModel: newModel.

	self assert: browser containedBrowser miSelectedItem size equals: 1.
	self
		assert: browser containedBrowser miSelectedItem anyOne name
		equals: 'Class2'
]

{ #category : #'tests - opening' }
MiModelRootBrowserTest >> testSettingsAction [

	self assert: browser containedBrowser hasSettings
]

{ #category : #tests }
MiModelRootBrowserTest >> testUpdateForNewModel [

	| model1 model2 |
	model1 := FamixStModel new
		          name: 'model1';
		          yourself.
	MooseModel root add: model1.
	
	browser containedBrowser updateList.
	
	model2 := FamixStModel new
		          name: 'model2';
		          yourself.
	MooseModel root add: model2.
	browser containedBrowser updateForNewModel: model2.

	self
		assertCollection: browser model mooseModelsList
		hasSameElements: { 
				model1.
				model2 }.
	self
		assert: browser containedBrowser model rawSelectedMooseModel
		equals: model2
]

{ #category : #tests }
MiModelRootBrowserTest >> testUpdateForNewModelMultipleBrowsers [

	| browser2 model1 model2 |
	model1 := FamixStModel new
		          name: 'model1';
		          yourself.
	MooseModel root add: model1.
	browser2 := self browserClass openForTests.
	browser containedBrowser updateList.

	self assert: browser model mooseModelsList size equals: 1.
	self assert: browser model rawSelectedMooseModel equals: model1.

	self assert: browser2 model mooseModelsList size equals: 1.
	self assert: browser2 model rawSelectedMooseModel equals: model1.

	model2 := FamixStModel new
		            name: 'model2';
		            yourself.
	MooseModel root add: model2.
	browser containedBrowser updateForNewModel: model2.

	self assert: browser model mooseModelsList size equals: 2.
	self assert: browser model rawSelectedMooseModel equals: model2.

	self assert: browser2 model mooseModelsList size equals: 2.
	self assert: browser2 model rawSelectedMooseModel equals: model1.

	browser2 window close
]

{ #category : #tests }
MiModelRootBrowserTest >> testUpdateList [

	| model |
	self assertEmpty: browser model mooseModelsList.

	model := FamixStModel new.
	MooseModel root add: model.

	browser containedBrowser updateList.

	self
		assertCollection: browser model mooseModelsList
		hasSameElements: { model }.
	self
		assert: (browser containedBrowser presenterAt: #modelFilteringList)
				listPresenter selectedItem
		equals: model.

	self assert: browser model rawSelectedMooseModel equals: model
]
