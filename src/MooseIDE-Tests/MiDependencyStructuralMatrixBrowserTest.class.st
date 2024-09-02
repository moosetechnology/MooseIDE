Class {
	#name : #MiDependencyStructuralMatrixBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> browserClass [
	^ MiDependencyStructuralMatrixBrowser
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> initializeEntityToSelect [

	^ {
		  (self method: 'method1').
		  (self method: 'method2').
		  (self method: 'method3') }
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	

]

{ #category : #'tests - tags' }
MiDependencyStructuralMatrixBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]
