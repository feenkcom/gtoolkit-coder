Class {
	#name : #GtCoderExamplesEventsRecorder,
	#superclass : #Object,
	#instVars : [
		'events'
	],
	#category : #'GToolkit-Coder-Examples-Support'
}

{ #category : #accessing }
GtCoderExamplesEventsRecorder >> events [
	^ events
]

{ #category : #accessing }
GtCoderExamplesEventsRecorder >> first [
	^ self events first
]

{ #category : #'gt-extensions' }
GtCoderExamplesEventsRecorder >> gtEventsFor: aView [

	<gtView>
	self events ifNil: [ ^ aView empty ].

	^ aView list
		  title: 'Events';
		  priority: 1;
		  items: [ self events ]
]

{ #category : #initialization }
GtCoderExamplesEventsRecorder >> initialize [
	super initialize.
	
	events := OrderedCollection new
]

{ #category : #testing }
GtCoderExamplesEventsRecorder >> isEmpty [
	^ events isEmpty
]

{ #category : #accessing }
GtCoderExamplesEventsRecorder >> numberOfEvents [
	^ events size
]

{ #category : #'api - recording' }
GtCoderExamplesEventsRecorder >> record: anAnnouncement [
	events add: anAnnouncement
]

{ #category : #accessing }
GtCoderExamplesEventsRecorder >> second [
	^ self events second
]

{ #category : #accessing }
GtCoderExamplesEventsRecorder >> third [
	^ self events third
]
