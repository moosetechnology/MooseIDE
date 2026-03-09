"
A MiInspectorBrowserTest is a test class for testing the behavior of MiInspectorBrowser
"
Class {
	#name : 'MiInspectorBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-NewTools-Tests',
	#package : 'MooseIDE-NewTools-Tests'
}

{ #category : 'tests - actions' }
MiInspectorBrowserTest >> assertFollowActionFor: aMooseObject [

	self assert: browser miInspector model equals: aMooseObject
	
]

{ #category : 'running' }
MiInspectorBrowserTest >> browserClass [

	^ MiInspectorBrowser
]

{ #category : 'running' }
MiInspectorBrowserTest >> inspectorNavigationTab [

	^ (browser instVarNamed: #mainPresenter) firstPagePresenter instVarNamed: #navigation
]

{ #category : 'tests' }
MiInspectorBrowserTest >> testCanPropagateMooseEntity [

	browser followEntity: MooseEntity new.

	self assert: browser canPropagate.
	self assert: (browser toolbarButton: 'Propagate') isEnabled

]

{ #category : 'tests' }
MiInspectorBrowserTest >> testCanPropagateMooseGroup [

	browser followEntity: self mooseObjects asMooseGroup.

	self assert: browser canPropagate.
	self assert: (browser toolbarButton: 'Propagate') isEnabled

]

{ #category : 'tests' }
MiInspectorBrowserTest >> testMetaNavigationItems [

	| classA classB |
	classA := FamixStClass new.
	classB := FamixStClass new.

	FamixStInheritance new
		superclass: classA;
		subclass: classB.

	self assert: classA miMetaNavigationItems size equals: 1.
	self assert: classA miMetaNavigationItems anyOne value isCollection.
	self
		assert: classA miMetaNavigationItems anyOne value anyOne
		equals: classB
]

{ #category : 'tests' }
MiInspectorBrowserTest >> testMetaNavigationItemsForMooseModel [

	| classA classB model |
	
	model := FamixStModel new.
	classA := model newClass.
	classB := model newClass.

	model newInheritance
		superclass: classA;
		subclass: classB.

	self assert: model miMetaNavigationItems size = 2. "An entry for Model Classes and one for Classes"
]

{ #category : 'tests' }
MiInspectorBrowserTest >> testMetaNavigationItemsWithMethod [

	| classB method |
	method := FamixJavaMethod new.
	classB := FamixJavaClass new.

	FamixJavaEntityTyping new
		typedEntity: method;
		declaredType: classB.

	self assert: method miMetaNavigationItems size equals: 1.
	self deny: method miMetaNavigationItems anyOne value isCollection.
	self assert: method miMetaNavigationItems anyOne value equals: classB
]

{ #category : 'tests' }
MiInspectorBrowserTest >> testNavigationTabIsSorted [

	| entity |
	self skip: 'Could not find a programatic way to access the items of Navigation tab to check that it is indeed orderd :-('.
	
	entity := FamixStClass new.
	entity addAttribute: FamixStAttribute new.
	entity addMethod: FamixStMethod new.
	entity addComment: FamixStComment new.
	entity typeContainer: FamixStPackage new.

	browser followEntity: entity.

	self inspectorNavigationTab inspect
]

{ #category : 'tests' }
MiInspectorBrowserTest >> testOutgoingInvocation [

	| method1 method2 inspectorTab |
	method1 := FamixStMethod new.
	method2 := FamixStMethod new.

	FamixStInvocation new
		sender: method1;
		candidates: { method2 }.

	browser followEntity: method1.
	inspectorTab := self inspectorNavigationTab.

	self shouldnt: [inspectorTab selectItem: inspectorTab roots second]  raise: Error
]

{ #category : 'tests - tags' }
MiInspectorBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]
