Class {
	#name : #MiListSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'selector'
	],
	#category : #'MooseIDE-Core-Widgets'
}

{ #category : #accessing }
MiListSelectorTest >> initialCollection [

	^ #( 1 2 3 4 5 6 7 8 )
]

{ #category : #accessing }
MiListSelectorTest >> initialList [

	^ (selector presenterAt: #initialList) listPresenter
]

{ #category : #accessing }
MiListSelectorTest >> selectAllButton [

	^ selector presenterAt: #selectAllButton
]

{ #category : #accessing }
MiListSelectorTest >> selectButton [

	^ selector presenterAt: #selectButton
]

{ #category : #accessing }
MiListSelectorTest >> selectedList [

	^ (selector presenterAt: #selectedList) listPresenter
]

{ #category : #running }
MiListSelectorTest >> setUp [

	super setUp.
	selector := MiListSelector new
]

{ #category : #tests }
MiListSelectorTest >> testEmptyIntialList [

	selector initialItems: {  }.
	self selectButton click.
	self assert: selector selectedItems isEmpty.
	self assert: self initialList items isEmpty
]

{ #category : #tests }
MiListSelectorTest >> testPreselectedItemsAreNotDuplicatedInInitialList [

	| preselected |
	preselected := #( 2 3 10 ).

	selector initialItems: self initialCollection.

	selector selectedItems: preselected.

	self denyCollection: self initialList items includesAny: preselected
]

{ #category : #tests }
MiListSelectorTest >> testSelectAll [

	selector initialItems: self initialCollection.
	self selectAllButton click.

	self
		assertCollection: selector selectedItems
		hasSameElements: self initialCollection.
	self assert: self initialList items isEmpty
]

{ #category : #tests }
MiListSelectorTest >> testSelectMultipleItems [

	| selectedItems |
	selector initialItems: self initialCollection.
	selectedItems := #( 1 8 5 ).
	
	self initialList selectItems: selectedItems.
	self selectButton click.
	
	self
		assertCollection: selector selectedItems
		hasSameElements: selectedItems.
	self
		assertCollection: self initialList items
		hasSameElements: self initialCollection \ selectedItems
]

{ #category : #tests }
MiListSelectorTest >> testSelectOneItem [

	selector initialItems: self initialCollection.
	self initialList selectItem: 1.
	self selectButton click.

	self assertCollection: selector selectedItems hasSameElements: { 1 }.
	self
		assertCollection: self initialList items
		hasSameElements: (2 to: 8)
]

{ #category : #tests }
MiListSelectorTest >> testUnselectAll [

	self selectedList items: self initialCollection.
	self unselectAllButton click.

	self
		assertCollection: self initialList items
		hasSameElements: self initialCollection.
	self assert: selector selectedItems isEmpty
]

{ #category : #tests }
MiListSelectorTest >> testUnselectMultipleItems [

	| selectedItems |
	self selectedList items: self initialCollection.
	selectedItems := #( 1 8 5 ).

	self selectedList selectItems: selectedItems.
	self unselectButton click.

	self
		assertCollection: self initialList items
		hasSameElements: selectedItems.
	self
		assertCollection: selector selectedItems
		hasSameElements: self initialCollection \ selectedItems
]

{ #category : #tests }
MiListSelectorTest >> testUnselectOneItem [

	self selectedList items: self initialCollection.
	self selectedList selectItem: 1.
	self unselectButton click.

	self assertCollection: self initialList items hasSameElements: { 1 }.
	self
		assertCollection: selector selectedItems
		hasSameElements: (2 to: 8)
]

{ #category : #accessing }
MiListSelectorTest >> unselectAllButton [ 

	^ selector presenterAt: #unselectAllButton
]

{ #category : #accessing }
MiListSelectorTest >> unselectButton [

	^ selector presenterAt: #unselectButton
]
