Class {
	#name : #MiCoAttributeTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #tests }
MiCoAttributeTest >> test01Method [

	| method |
	method := MiCoMethod new.
	method
		name: #method1;
		usedAttributes: #(  ).
	self assert: method asString equals: #method1
]

{ #category : #tests }
MiCoAttributeTest >> test02Attribute [

	| attribute |
	attribute := MiCoAttribute new.
	attribute
		name: #var1;
		usedInMethods: #(  ).
	self assert: attribute asString equals: #var1
]

{ #category : #tests }
MiCoAttributeTest >> test03PopupMessage [

	| attribute method |
	attribute := MiCoAttribute new.
	attribute
		name: #var1;
		method: (method := MiCoMethod new name: #method1) counter: 3;
		method: (MiCoMethod new name: #method2) counter: 6;
		method: (MiCoMethod new name: #method3) counter: 1;
		method: (MiCoMethod new name: #method8) counter: 2.
	self
		assert: (attribute asStringForMethod: method)
		equals: ('Accesses for var1:

3 access from this method(method1)
9 access from 3 local methods'
				 copyReplaceAll: String cr
				 with: String crlf).
	attribute := MiCoAttribute new.
	attribute
		name: #var2;
		method: (method := MiCoMethod new name: #method5) counter: 4.
	self
		assert: (attribute asStringForMethod: method)
		equals: ('Accesses for var2:

4 access from this method(method5)'
				 copyReplaceAll: String cr
				 with: String crlf).
	attribute := MiCoAttribute new.
	attribute
		name: #var2;
		method: (method := MiCoMethod new name: #method5) counter: 4;
		method: (MiCoMethod new name: #method6) counter: 9.
	self
		assert: (attribute asStringForMethod: method)
		equals: ('Accesses for var2:

4 access from this method(method5)
9 access from 1 local method'
				 copyReplaceAll: String cr
				 with: String crlf)
]
