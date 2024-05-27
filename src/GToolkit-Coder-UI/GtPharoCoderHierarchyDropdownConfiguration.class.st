Class {
	#name : #GtPharoCoderHierarchyDropdownConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'preferredExtent'
	],
	#category : #'GToolkit-Coder-UI'
}

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
	^ preferredExtent ifNil: [ preferredExtent := 400 @ 400 ]
]

{ #category : #accessing }
GtPharoCoderHierarchyDropdownConfiguration class >> preferredExtent: anObject [
	preferredExtent := anObject
]
