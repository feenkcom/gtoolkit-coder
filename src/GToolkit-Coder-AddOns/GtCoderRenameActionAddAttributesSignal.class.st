Class {
	#name : #GtCoderRenameActionAddAttributesSignal,
	#superclass : #GtCoderRenameActionSignal,
	#instVars : [
		'coderAttributes'
	],
	#category : #'GToolkit-Coder-AddOns-Signals'
}

{ #category : #accessing }
GtCoderRenameActionAddAttributesSignal >> coderAttributes [
	^ coderAttributes
]

{ #category : #accessing }
GtCoderRenameActionAddAttributesSignal >> coderAttributes: anObject [
	coderAttributes := anObject
]

{ #category : #'gt - extensions' }
GtCoderRenameActionAddAttributesSignal >> gtExtraTextAttributesFor: aView [
	<gtView>
	coderAttributes ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Extra Text Attributes';
		priority: 0;
		items: [ coderAttributes ];
		column: 'Document'
			text: [ :each | 
				'{1}.{2}'
					format: {each documentId ifNotNil: #textId ifNil: [ '-' ].
							each documentId ifNotNil: #textId ifNil: [ '-' ]} ]
			width: 70;
		column: 'Range'
			text: [ :each | 
				'{1}..{2}'
					format: {each startPosition ifNil: [ '-' ].
							each stopPosition ifNil: [ '-' ]} ]
			width: 50;
		column: 'Count'
			text: [ :each | each textAttributes ifNotNil: #size ifNil: [ 0 ] ]
			width: 50;
		column: 'Attributes'
			text: [ :each | 
				each textAttributes
					ifNotNil: [ :aCollection | 
						String
							streamContents: [ :aStream | 
								aCollection
									do: [ :eachAttribute | eachAttribute gtDisplayOn: aStream ]
									separatedBy: [ aStream nextPut: ', ' ] ] ]
					ifNil: [ '' ] ]
]

{ #category : #printing }
GtCoderRenameActionAddAttributesSignal >> printOneLineContentsOn: aStream [
	action ifNil: [ ^ super printOneLineContentsOn: aStream ].

	aStream nextPutAll: '+A '.
	action documentId gtDisplayOn: aStream.
	aStream space.
	action newSelector gtDisplayOn: aStream
]
