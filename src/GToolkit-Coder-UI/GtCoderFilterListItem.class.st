Class {
	#name : #GtCoderFilterListItem,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'item',
		'title',
		'action'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'api - actions' }
GtCoderFilterListItem >> actOnEvent: anEvent [
	self action cull: self item cull: self cull: anEvent
]

{ #category : #'api - accessing' }
GtCoderFilterListItem >> action [
	^ action
]

{ #category : #'api - accessing' }
GtCoderFilterListItem >> action: anObject [
	action := anObject
]

{ #category : #'api - accessing' }
GtCoderFilterListItem >> item [
	^ item
]

{ #category : #'api - accessing' }
GtCoderFilterListItem >> item: anObject [
	item := anObject
]

{ #category : #'api - accessing' }
GtCoderFilterListItem >> title [
	^ title cull: self item cull: self
]

{ #category : #'api - accessing' }
GtCoderFilterListItem >> title: anObject [
	title := anObject
]
