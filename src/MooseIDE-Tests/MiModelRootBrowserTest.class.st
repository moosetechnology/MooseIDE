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
MiModelRootBrowserTest >> newModel: aString [
	| model |
	model := FamixStModel new
		name: aString ;
		yourself.
	MooseModel root add: model.
	^model
]

{ #category : #running }
MiModelRootBrowserTest >> setUp [

	savedRoot := MooseModelRoot installedRoot.
	MooseModelRoot resetRoot.
	super setUp
]

{ #category : #tests }
MiModelRootBrowserTest >> stModelFile [
	"Creating an in-memory JSON file containing a class from FamixStModel"
	| file model |
	model := FamixStModel new.
	FamixStClass named: 'AClass' model: model.

	file := FileSystem workingDirectory / 'stModel.json'.
	file writeStreamDo: [ :stream | model exportToJSONStream: stream ].
	^file
]

{ #category : #running }
MiModelRootBrowserTest >> tearDown [

	MooseModelRoot installRoot: savedRoot.
	super tearDown
]

{ #category : #tests }
MiModelRootBrowserTest >> testActivateActionButtons [

	| newModel |
	self assert: browser actionButtons isNotEmpty.
	browser actionButtons do: [ :button | self deny: button isEnabled ].

	newModel := self newModel: 'aModel'.
	browser updateForNewModel: newModel.

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiModelRootBrowserTest >> testFilterStubsSettingsWithoutStub [

	| newModel |
	self assert: browser miSelectedItem isNil.

	newModel := self newModel: 'aModel'.
	newModel addAll: { 
			(FamixStClass named: 'Class1') isStub: true; yourself.
			(FamixStClass named: 'Class2') isStub: false; yourself}.
	browser updateForNewModel: newModel.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne name equals: 'Class2'.

	browser settingsItem setItem: #filterStubsSetting value: false.
	browser updateForNewModel: newModel.
	self assert: browser miSelectedItem size equals: 2.

	
]

{ #category : #tests }
MiModelRootBrowserTest >> testHandleDropFileImportsModel [
	| file |
	file := self stModelFile.

	self assertEmpty: browser model mooseModelsList.

	browser handleDropFileAndImport: file.

	"Must wait a bit to ensure model finishes importing.
	 Also need to update list manually because only browsers in MiApplication are updated
	 and this one is in MiApplicationTest"
	[ 0.5 second wait.
	  browser updateList ]
	ensure: [ file delete ]. 
	
	self assert: browser model mooseModelsList size equals: 1.
]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItem [

	| newModel |
	self assert: browser miSelectedItem isNil.

	newModel := self newModel: 'aModel'.
	browser updateForNewModel: newModel.

	self deny: browser miSelectedItem isNil
]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItemWithoutStub [

	| newModel |
	self assert: browser miSelectedItem isNil.

	newModel := self newModel: 'aModel'.
	newModel addAll: { 
			(FamixStClass named: 'Class1') isStub: true; yourself.
			(FamixStClass named: 'Class2') isStub: false; yourself}.
	browser updateForNewModel: newModel.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne name equals: 'Class2'
	

	
]

{ #category : #'tests - opening' }
MiModelRootBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiModelRootBrowserTest >> testUpdateForNewModel [

	| newModel |
	self newModel: 'model1'.
	browser updateList.

	self assert: browser model mooseModelsList size equals: 1.
	self assert: browser model rawSelectedMooseModel isNil.

	newModel := self newModel: 'model2'.
	browser updateForNewModel: newModel.

	self assert: browser model mooseModelsList size equals: 2.
	self assert: browser model rawSelectedMooseModel equals: newModel
]

{ #category : #tests }
MiModelRootBrowserTest >> testUpdateForNewModelMultipleBrowsers [

	| browser2 newModel |
	self newModel: 'model1'.
	browser2 := self browserClass openForTests: self application.
	browser updateList.

	self assert: browser model mooseModelsList size equals: 1.
	self assert: browser model rawSelectedMooseModel isNil.

	self assert: browser2 model mooseModelsList size equals: 1.
	self assert: browser2 model rawSelectedMooseModel isNil.

	newModel := self newModel: 'model2'.
	browser updateForNewModel: newModel.

	self assert: browser model mooseModelsList size equals: 2.
	self assert: browser model rawSelectedMooseModel equals: newModel.

	self assert: browser2 model mooseModelsList size equals: 2.
	self assert: browser2 model rawSelectedMooseModel isNil.

	browser2 window close
]

{ #category : #tests }
MiModelRootBrowserTest >> testUpdateList [

	self assertEmpty: browser model mooseModelsList.

	self newModel: 'aModel'.
	browser updateList.

	self assert: browser model mooseModelsList size equals: 1
]
