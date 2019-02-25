Class {
	#name : #GtSearchMethodsContainedInClassFilterExamples,
	#superclass : #GtSearchMethodFilterExamples,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtSearchMethodsContainedInClassFilterExamples >> methodsInClassFilter [
	<gtExample>
	| filter |
	filter := GtSearchMethodsInClassFilter forClass: GtSystemS1SubclassC2.
	
	self assert: (filter matches: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	self assert: (filter matches: GtSystemS1SubclassC2 class>>#stubMethodOnClassSideOfC2S1) not.
	
	^ filter
]

{ #category : #'examples - equality' }
GtSearchMethodsContainedInClassFilterExamples >> methodsInClassFilterEquality [
	<gtExample>
	| filter |
	filter := self methodsInClassFilter.
	self assert: filter equals: filter.
	self 
		assert: filter
		equals: (GtSearchMethodsInClassFilter forClass: GtSystemS1SubclassC2).
	^ filter
]

{ #category : #examples }
GtSearchMethodsContainedInClassFilterExamples >> methodsInClassFilterResultType [
	<gtExample>
	| filter |
	filter := self methodsInClassFilter.
	self assertMethodResultTypeForFilter: filter.
	self assert: filter defaultFilterScope == filter.
	^ filter
]

{ #category : #examples }
GtSearchMethodsContainedInClassFilterExamples >> methodsInClassOnBothSidesFilter [
	<gtExample>
	| filter |
	filter := GtSearchMethodsInInstanceAndClassSideFilter forClass: GtSystemS1SubclassC2.

	self assert: (filter matches: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	self assert: (filter matches: GtSystemS1SubclassC2 class>>#stubMethodOnClassSideOfC2S1).
		
	^ filter
]

{ #category : #'examples - equality' }
GtSearchMethodsContainedInClassFilterExamples >> methodsInClassOnBothSidesFilterEquality [
	<gtExample>
	| filter |
	filter := self methodsInClassOnBothSidesFilter.
	self assert: filter equals: filter.
	self 
		assert: filter
		equals: (GtSearchMethodsInInstanceAndClassSideFilter forClass: GtSystemS1SubclassC2).
	^ filter
]

{ #category : #examples }
GtSearchMethodsContainedInClassFilterExamples >> methodsInTwoClassesBothSidesUnionFilter [
	<gtExample>
	| filter |
	filter := GtSearchUnionFilter new
		filter: (GtSearchMethodsInInstanceAndClassSideFilter forClass: GtSystemS1SubclassC2)
		filter: (GtSearchMethodsInInstanceAndClassSideFilter forClass: GtSystemS1AnotherClassC3).
		
	self assert: (filter matches: GtSystemS1AnotherClassC3>>#oneMethodOnS1C3).
	self assert: (filter matches: GtSystemS1AnotherClassC3 class>>#isDeprecated).
	self assert: (filter matches: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	self assert: (filter matches: GtSystemS1SubclassC2 class>>#stubMethodOnClassSideOfC2S1).
		
	^ filter
]

{ #category : #examples }
GtSearchMethodsContainedInClassFilterExamples >> methodsInTwoClassesUnionFilter [
	<gtExample>
	| filter |
	filter := GtSearchUnionFilter new
		filter: (GtSearchMethodsInClassFilter forClass: GtSystemS1SubclassC2)
		filter: (GtSearchMethodsInClassFilter forClass: GtSystemS1AnotherClassC3).
		
	self assert: (filter matches: GtSystemS1AnotherClassC3>>#oneMethodOnS1C3).
	self assert: (filter matches: GtSystemS1AnotherClassC3 class>>#isDeprecated) not.
	self assert: (filter matches: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	self assert: (filter matches: GtSystemS1SubclassC2 class>>#stubMethodOnClassSideOfC2S1) not.
		
	^ filter
]

{ #category : #examples }
GtSearchMethodsContainedInClassFilterExamples >> methodsInTwoClassesUnionFilterResultType [
	<gtExample>
	| filter |
	filter := self methodsInTwoClassesUnionFilter.
	self assertMethodResultTypeForFilter: filter.
	self assert: filter defaultFilterScope == filter.
	^ filter
]

{ #category : #'examples - result' }
GtSearchMethodsContainedInClassFilterExamples >> resultGroupForMethodsInClassFilter [
	<gtExample>
	| filter result |
	filter := self methodsInClassFilter.
	result := filter result.
	
	self 
		assert: result size 
		equals: (GtSystemS1SubclassC2 instanceSide methods size).
	self assert: (result includes: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	self assert: (result includes: GtSystemS1SubclassC2 class>>#stubMethodOnClassSideOfC2S1) not.
	
	self assert: result class equals: GtSearchMethodGroupResult.
	self assert: result filter equals: filter.
	self assert: result scope == filter.
	
	^ result
]

{ #category : #'examples - result' }
GtSearchMethodsContainedInClassFilterExamples >> resultGroupForMethodsInTwoClassesBothSidesUnionFilter [
	<gtExample>
	| filter result |
	filter := self methodsInTwoClassesBothSidesUnionFilter.
	result := filter result.
	
	self 
		assert: result size 
		equals: (GtSystemS1SubclassC2 instanceSide methods size 
			+ GtSystemS1SubclassC2 classSide methods size
			+ GtSystemS1AnotherClassC3 instanceSide methods size
			+ GtSystemS1AnotherClassC3 classSide methods size).
	self assert: (result includes: GtSystemS1AnotherClassC3 class>>#isDeprecated).
	self assert: (result includes: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	self assert: (result includes: GtSystemS1SubclassC2 class>>#stubMethodOnClassSideOfC2S1).
	
	self assert: result class equals: GtSearchMethodGroupResult.
	self assert: result filter equals: filter.
	self assert: result scope == filter.
			
	^ result
]

{ #category : #'examples - result' }
GtSearchMethodsContainedInClassFilterExamples >> resultGroupForMethodsInTwoClassesUnionFilter [
	<gtExample>
	| filter result |
	filter := self methodsInTwoClassesUnionFilter.
	result := filter result.
	
	self 
		assert: result size 
		equals: (GtSystemS1SubclassC2 instanceSide methods size 
			+ GtSystemS1AnotherClassC3 instanceSide methods size).
	self assert: (result includes: GtSystemS1AnotherClassC3>>#oneMethodOnS1C3).
	self assert: (result includes: GtSystemS1AnotherClassC3 class>>#isDeprecated) not.
	self assert: (result includes: GtSystemS1SubclassC2>>#stubMethodInClassC2S1).
	
	self assert: result class equals: GtSearchMethodGroupResult.
	self assert: result filter equals: filter.
	self assert: result scope == filter.
		
	^ result
]
