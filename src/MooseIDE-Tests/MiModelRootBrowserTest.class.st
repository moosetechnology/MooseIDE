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
	self assert: browser actionButtons isNotEmpty.
	browser actionButtons do: [ :button | self deny: button isEnabled ].

	newModel := MooseModel new.
	MooseModel root add: newModel.
	browser updateForNewModel: newModel.

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItem [

	| newModel |
	self assert: browser miSelectedItem isNil.

	newModel := MooseModel new.
	MooseModel root add: newModel.
	browser updateForNewModel: newModel.

	self deny: browser miSelectedItem isNil
]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItemWithoutStub [

	| newModel |
	self assert: browser miSelectedItem isNil.

	newModel := FamixStModel new.
	newModel addAll: { 
			(FamixStClass named: 'Class1') isStub: true; yourself.
			(FamixStClass named: 'Class2') isStub: false; yourself}.
			
	
	MooseModel root add: newModel.
	browser updateForNewModel: newModel.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne name equals: 'Class2'
	

	
]
