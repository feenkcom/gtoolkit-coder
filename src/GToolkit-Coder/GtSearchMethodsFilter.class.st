Class {
	#name : #GtSearchMethodsFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchMethodsFilter class >> createFilterFor: aMethodCoder [
	^ self new
]

{ #category : #accessing }
GtSearchMethodsFilter class >> filterDescriptorFor: aMethodCoder [
	^ nil
]

{ #category : #accessing }
GtSearchMethodsFilter class >> resultType [
	^ GtSearchMethodGroupResult 
]

{ #category : #accessing }
GtSearchMethodsFilter >> defaultFilterScope [
	^ GtSearchImageMethodsFilter new
]

{ #category : #testing }
GtSearchMethodsFilter >> gtMetricsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Metrics';
		items: [ {('Number of methods' -> self size).
			('Lines of code' -> self linesOfCode).
			('Lines per method' -> (self linesOfCode / self size) asFloat)} ];
		column: 'Metric' text: #key;
		column: 'Value' text: [ :assoc | assoc value asString ]
]

{ #category : #testing }
GtSearchMethodsFilter >> includesMethod: aCompiledMethod [
	self subclassResponsibility
]

{ #category : #accessing }
GtSearchMethodsFilter >> linesOfCode [
	^ self result sumNumbers: [:method | method linesOfCode]
]

{ #category : #testing }
GtSearchMethodsFilter >> matches: anObject [
	^ anObject isCompiledMethod and: [ 
		self includesMethod: anObject ]
]
