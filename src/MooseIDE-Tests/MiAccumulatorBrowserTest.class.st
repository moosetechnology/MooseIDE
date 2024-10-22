Class {
	#name : #MiAccumulatorBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiAccumulatorBrowserTest >> browserClass [

	^MiAccumulatorBrowser
]

{ #category : #running }
MiAccumulatorBrowserTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : #running }
MiAccumulatorBrowserTest >> testCanPropagateAfterFollow [

	browser followEntity: { (self method: 'method1') . (self method: 'method2') }.

	self assert: browser canPropagate.

]

{ #category : #running }
MiAccumulatorBrowserTest >> testCannotPropagateWhenEmpty [

	self deny: browser canPropagate.

]

{ #category : #running }
MiAccumulatorBrowserTest >> testClearEntities [

	browser followEntity: { (self method: 'method1') . (self method: 'method2') }.

	self denyEmpty: browser model entities.

	browser btnClear click.
	self assertEmpty: browser model entities
]

{ #category : #running }
MiAccumulatorBrowserTest >> testFollowEntity [

	self assertEmpty: browser model entities.

	browser followEntity: { (self method: 'method1') . (self method: 'method2') }.

	self assert: browser model entities size equals: 2
]

{ #category : #running }
MiAccumulatorBrowserTest >> testMiSelectedItemWithSelection [

	| entities |

	entities := { (self method: 'method1') . (self method: 'method2') }.

	browser followEntity: entities.
	browser model selectedEntities: { entities first }.

	self assert: browser miSelectedItem size equals: 1
]

{ #category : #running }
MiAccumulatorBrowserTest >> testMiSelectedItemWithoutSelection [

	browser followEntity: { (self method: 'method1') . (self method: 'method2') }.

	self assert: browser miSelectedItem size equals: 2
]

{ #category : #running }
MiAccumulatorBrowserTest >> testRemoveEntities [

	| entities |

	entities := { (self method: 'method1') . (self method: 'method2') }.

	browser followEntity: entities.
	browser model selectedEntities: { entities first }.

	self assert: browser model entities size equals: 2.

	browser btnRemove click.

	self assert: browser model entities size equals: 1
]
