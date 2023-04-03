Class {
	#name : #MiCoMenuManagerTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoMenuManagerTest >> testOpenMenu [

	| attribute method |
	self tagsWithPalette: { 'base'. 'simple' }.
	self buildForTest.

	attribute := builder innerBoxNamed: #var2.
	method := builder containerBoxNamed: #method1.
	builder menuManager createMenu: MenuMorph new onBox: attribute.
	builder menuManager createMenu: MenuMorph new onBox: method.
	builder menuManager
		createGlobalMenuOn: MenuMorph new;
		createMenu: MenuMorph new onShape: builder canvas
]
