Class {
	#name : #MiVisualizationThemeTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #tests }
MiVisualizationThemeTest >> testDefaultIconForTClass [
	| theme |
	theme := MiVisualizationTheme new.

	self assert: (theme mooseIconNameFor: FamixJavaClass new) equals: #famixClass.
	self assert: (theme mooseIconNameFor: FamixStClass new) equals: #famixClass.
	self deny: (theme mooseIconNameFor: FamixJavaMethod new) equals: #famixClass.
]

{ #category : #tests }
MiVisualizationThemeTest >> testDefaultIconForTMethod [
	| theme |
	theme := MiVisualizationTheme new.

	self assert: (theme mooseIconNameFor: FamixJavaMethod new) equals: #famixMethod.
	self assert: (theme mooseIconNameFor: FamixStMethod new) equals: #famixMethod.
	self deny: (theme mooseIconNameFor: FamixJavaAttribute new) equals: #famixMethod.
]

{ #category : #tests }
MiVisualizationThemeTest >> testNonDefaultIconTheme [
	| theme |
	theme := MiVisualizationTheme new.
	
	theme iconTheme: { FamixTClass -> #blah }.

	self assert: (theme mooseIconNameFor: FamixJavaMethod new) isNil.
	self assert: (theme mooseIconNameFor: FamixJavaClass new) equals: #blah.
]

{ #category : #tests }
MiVisualizationThemeTest >> testRecursiveSearchOfTrait [
	| theme |
	theme := MiVisualizationTheme new.
	
	theme iconTheme: { FamixTAccessible -> #blah }.

	self assert: (theme mooseIconNameFor: FamixJavaLocalVariable new) equals: #blah.
]
