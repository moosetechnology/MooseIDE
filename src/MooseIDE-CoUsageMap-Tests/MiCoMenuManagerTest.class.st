Class {
	#name : #MiCoMenuManagerTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoMenuManagerTest >> testOpenMenu [

	| attribute method |
	attribute := self specModel getInnerBoxNamed: #var2.
	method := self specModel containerBoxNamed: #method1.
	builder menuManager createMenu: MenuMorph new onBox: attribute.
	builder menuManager createMenu: MenuMorph new onBox: method.
	builder menuManager
		createGlobalMenuOn: MenuMorph new;
		createMenu: MenuMorph new onShape: builder canvas
]
