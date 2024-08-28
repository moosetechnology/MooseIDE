Class {
	#name : #MiDependencyStructuralMatrixBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> browserClass [
	^ MiDependencyStructuralMatrixBrowser
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> setUp [
	super setUp.

	entityToSelect := { self method: 'method1' . self method: 'method2' . self method: 'method3' }
]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	

]

{ #category : #'tests - tags' }
MiDependencyStructuralMatrixBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]
