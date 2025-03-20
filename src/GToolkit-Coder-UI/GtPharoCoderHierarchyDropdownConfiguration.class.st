Class {
	#name : #GtPharoCoderHierarchyDropdownConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'preferredExtent'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #cleanup }
GtPharoCoderHierarchyDropdownConfiguration class >> cleanUp: aggressive [
	aggressive ifTrue: [ preferredExtent := nil ]
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> defaultPreferredExtent [
	^ 800 @ 400
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> gtConfiguration [
	^ {GtPhlowOverviewItem new
			name: 'Preferred extent';
			value: self preferredExtent}
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> gtConfigurationFor: aView [
	<gtView>
	<gtClassView>
	^ aView columnedList
		title: 'Configuration';
		priority: 40;
		actionUpdateButton;
		items: [ self gtConfiguration ];
		column: 'Name' text: #name;
		column: 'Value' text: #description;
		send: #value
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> preferredExtent [
	^ preferredExtent ifNil: [ preferredExtent := self defaultPreferredExtent ]
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> preferredExtent: anObject [
	preferredExtent := anObject
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> preferredExtentOrNil [
	"Just for testing purposes."

	^ preferredExtent
]
