Class {
	#name : #MiCoAttributeTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoAttributeTest >> test01Method [

	| method |
	method := MiCoContainerBox new.
	method
		name: #method1;
		usedAttributes: #(  ).
	self assert: method asString equals: #method1
]

{ #category : #tests }
MiCoAttributeTest >> test02Attribute [

	| attribute |
	attribute := MiCoInnerBox new.
	attribute
		name: #var1;
		usedInMethods: #(  ).
	self assert: attribute asString equals: #var1
]

{ #category : #tests }
MiCoAttributeTest >> test03PopupMessage [

	| attribute method |
	attribute := MiCoInnerBox new.
	attribute
		name: #var1;
		method: (method := MiCoContainerBox new name: #method1) counter: 3;
		method: (MiCoContainerBox new name: #method2) counter: 6;
		method: (MiCoContainerBox new name: #method3) counter: 1;
		method: (MiCoContainerBox new name: #method8) counter: 2.
	self
		assert: (attribute asStringForMethod: method)
		equals: ('Links for var1:

3 links from this container(method1)
9 links from 3 local containers'
				 copyReplaceAll: String cr
				 with: String crlf).
	attribute := MiCoInnerBox new.
	attribute
		name: #var2;
		method: (method := MiCoContainerBox new name: #method5) counter: 4.
	self
		assert: (attribute asStringForMethod: method)
		equals: ('Links for var2:

4 links from this container(method5)'
				 copyReplaceAll: String cr
				 with: String crlf).
	attribute := MiCoInnerBox new.
	attribute
		name: #var2;
		method: (method := MiCoContainerBox new name: #method5) counter: 4;
		method: (MiCoContainerBox new name: #method6) counter: 9.
	self
		assert: (attribute asStringForMethod: method)
		equals: ('Links for var2:

4 links from this container(method5)
9 links from 1 local container'
				 copyReplaceAll: String cr
				 with: String crlf)
]
