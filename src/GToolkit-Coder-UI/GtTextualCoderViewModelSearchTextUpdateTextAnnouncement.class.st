Class {
	#name : #GtTextualCoderViewModelSearchTextUpdateTextAnnouncement,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'consumed',
		'styledText',
		'isUpdated'
	],
	#category : 'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtTextualCoderViewModelSearchTextUpdateTextAnnouncement >> consumed [
	^ consumed ifNil: [ false ]
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextUpdateTextAnnouncement >> consumed: aBoolean [
	consumed := aBoolean
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextUpdateTextAnnouncement >> isUpdated [
	^ isUpdated ifNil: [ false ]
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextUpdateTextAnnouncement >> isUpdated: aBoolean [
	isUpdated := aBoolean
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextUpdateTextAnnouncement >> styledText [
	^ styledText
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextUpdateTextAnnouncement >> styledText: anObject [
	styledText := anObject
]
