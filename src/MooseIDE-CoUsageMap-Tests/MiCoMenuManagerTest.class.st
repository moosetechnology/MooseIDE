Class {
	#name : 'MiCoMenuManagerTest',
	#superclass : 'MiCoUsageAbstractTest',
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'tests' }
MiCoMenuManagerTest >> testOpenMenu [

	| attribute method |
	attribute := self specModel getInnerBoxNamed: #att3.
	method := self specModel containerBoxNamed: #method3.
	builder menuManager createMenu: MenuMorph new onBox: attribute.
	builder menuManager createMenu: MenuMorph new onBox: method.
	builder menuManager
		createGlobalMenuOn: MenuMorph new;
		createMenu: MenuMorph new onShape: builder canvas
]
