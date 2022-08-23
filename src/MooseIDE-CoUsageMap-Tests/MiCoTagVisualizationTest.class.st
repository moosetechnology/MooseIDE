Class {
	#name : #MiCoTagVisualizationTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoTagVisualizationTest >> test01Legend [

	| v class legendTag tag1 tag2 |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	legendTag := MiCoTagBuilder new.
	v
		legendTag: legendTag;
		build.
	self assert: legendTag shapes size equals: 1.
	tag1 := MiCoTag new
		name: 'Frame';
		color: Color lightBlue;
		yourself.
	legendTag addTag: tag1.
	tag2 := MiCoTag new
		name: 'Connection';
		color: Color green;
		yourself.
	legendTag addTag: tag2.
	v build.
	self assert: legendTag shapes size equals: 3
]

{ #category : #tests }
MiCoTagVisualizationTest >> testToggleTag [
	| v class tag tagShape |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	
	tag := MiCoTag new
		name: 'Frame';
		color: Color lightBlue;
		yourself.
	v legendTag addTag: tag.
	v build.
	self assert: v legendTag shapes size equals: 2.
	tagShape := v legendTag shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.
	v legendTag toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]
