Class {
	#name : 'MiUMLModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'selected',
		'showAttributes',
		'showMethods'
	],
	#category : 'MooseIDE-Famix-UML',
	#package : 'MooseIDE-Famix',
	#tag : 'UML'
}

{ #category : 'settings management' }
MiUMLModel >> currentConfiguration [

	^ MiUMLSettingsConfiguration new
		  showAttributes: showAttributes;
		  showMethods: showMethods;
		  yourself
]

{ #category : 'settings management' }
MiUMLModel >> defaultConfiguration [

	^ MiUMLSettingsConfiguration new
]

{ #category : 'accessing' }
MiUMLModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiUMLModel >> entities: anObject [

	entities := anObject
]

{ #category : 'testing' }
MiUMLModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiUMLModel >> initialize [

	showAttributes := true.
	showMethods := false
]

{ #category : 'accessing' }
MiUMLModel >> selected [

	^ selected
]

{ #category : 'accessing' }
MiUMLModel >> selected: anObject [

	selected := anObject
]

{ #category : 'accessing' }
MiUMLModel >> showAttributes [

	^ showAttributes
]

{ #category : 'accessing' }
MiUMLModel >> showAttributes: aBoolean [

	showAttributes := aBoolean
]

{ #category : 'accessing' }
MiUMLModel >> showMethods [

	^ showMethods
]

{ #category : 'accessing' }
MiUMLModel >> showMethods: aBoolean [

	showMethods := aBoolean
]

{ #category : 'api - selection' }
MiUMLModel >> unselectAll [

	selected := nil
]

{ #category : 'settings management' }
MiUMLModel >> updateFromConfiguration: aConfiguration [

	showAttributes := aConfiguration showAttributes.
	showMethods := aConfiguration showMethods.
	browser runVisualization
]
