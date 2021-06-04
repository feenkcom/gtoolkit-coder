"
Is sent by the {{gtClass:GtCoderModel}} when the addons should be recomputed.

It works like this:
1) The coder model detects some changes that may requere the addons to be recomputed
2) Coder notifies all listeners that now is the time to update the addons
3) If there are any listeners they tell coder to start the update of the addons (in a background process)
4) Once finished, the coder sends more fine grained announcements about individual changes in the addons


"
Class {
	#name : #GtCoderAddOnsUpdateRequest,
	#superclass : #GtCoderAnnouncement,
	#category : #'GToolkit-Coder-Event'
}
