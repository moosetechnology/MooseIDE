Class {
	#name : #MiCoAttributeTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoAttributeTest >> containerBoxOn: aName [
	^MiCoContainerBox new mooseEntity: (FamixStMethod new name: aName)
]

{ #category : #tests }
MiCoAttributeTest >> innerBoxOn: aName [
	^MiCoInnerBox new mooseEntity: (FamixStAttribute new name: aName)
]

{ #category : #tests }
MiCoAttributeTest >> test01ContainerBox [

	| container |
	container := self containerBoxOn: 'method1'.
	self assert: container asString equals: 'method1'
]

{ #category : #tests }
MiCoAttributeTest >> test02InnerBox [

	| innerBox |
	innerBox := self innerBoxOn: 'aVar'.
	self assert: innerBox asString equals: 'aVar'
]

{ #category : #tests }
MiCoAttributeTest >> test03PopupMessage [

	| innerBox containerBox |
	containerBox := self containerBoxOn: 'method1'.
	innerBox := self innerBoxOn: 'var1'.
	innerBox
		containerBox: containerBox numberOfUses: 3;
		containerBox: (self containerBoxOn: 'method2') numberOfUses: 6;
		containerBox: (self containerBoxOn: 'method3') numberOfUses: 1;
		containerBox: (self containerBoxOn: 'method4') numberOfUses: 2.
	self
		assert: (innerBox asStringForContainerBox: containerBox)
		equals: ('Links for <var1>:

3 links from this container(method1)
9 links from 3 local containers'
				 copyReplaceAll: String cr
				 with: String crlf).

	innerBox := self innerBoxOn: 'var2'.
	containerBox := self containerBoxOn: 'method5'.
	innerBox
		containerBox: containerBox numberOfUses: 4.
	self
		assert: (innerBox asStringForContainerBox: containerBox)
		equals: ('Links for <var2>:

4 links from this container(method5)'
				 copyReplaceAll: String cr
				 with: String crlf).

	innerBox
		containerBox: (self containerBoxOn: 'method6') numberOfUses: 9.
	self
		assert: (innerBox asStringForContainerBox: containerBox)
		equals: ('Links for <var2>:

4 links from this container(method5)
9 links from 1 local container'
				 copyReplaceAll: String cr
				 with: String crlf)
]
