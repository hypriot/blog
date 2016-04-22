+++
Categories = ["Blog"]
Tags = ["blog"]
date = "2015-03-27T22:52:37+01:00"
title = "We moved our blog from Posthaven to Hugo after only three posts. Why?"
more_link = "yes"

+++
Today we made the move and switched our blog from [Posthaven](http://posthaven.com) to [Hugo](http://gohugo.io/).
And that after having published only three blog posts. You might ask yourself why?
<!--more-->

## In the beginning there was Posthaven
Well when we first were looking for place to start our blog it was all about getting started fast without much effort.
We also wanted something simple which wouldn't cost a fortune. Posthaven seemed to fit the bill perfectly. It just cost us 5$/month and we had it up and running in half an hour.
And that is including setting it up to work with a custom domain and Google Analytics support.

But after a couple of weeks it already felt like it had too many restrictions.
For instance there was nearly no support for adjusting the look and feel of the blog. Only some basic CSS styling was possible.
After contacting the support I was told that some theming support was in the pipeline but no concrete release date was available.

Another problem was that it was very difficult to add some non-blog-post-style pages like 'About' or 'legal notice'. One could create such pages but these had an empty author field which was shown to visitors.
Not very satisfying.

Another nuisance was that the Google Analytics support was only very basic. It was not possible to add any custom analytics code to blog posts - for instance to track download links with custom tracking events.

And last but not least it was difficult to add syntax highlighted text to the blog. We found the advise to use Github Gists instead somewhere but we could not find out a way to honour the gists CSS styling after embedding the its link in our post.
That was the final event that pushed us towards trying another solution.

We already had this other solution on our radar from the beginning but were hesitant to use it because we had been afraid that it would be a big time sink. And we had been right.

## ... then there came Hugo
Hugo is a so-called static-blog generator similar to [Jekyll](http://jekyllrb.com/).
It is able to generate a complete blog from text files you write with [Markdown](http://daringfireball.net/projects/markdown).
As markdown is just a text format it can be easily managed with a revison control system like Git.

That comes in especially handy if you write blog posts as part of a team. Thus changes can easily be tracked and coordinated until a post is ready to be published.

## ... and we paid the price.
All in all it took us about 20 hours to move the old blog to Hugo.  
That not only includes the time to learn all about Hugo but also the time to find a suitable theme as a starting point for our own and to implement a responsive image gallery.
Furthermore we needed to add support for social sharing and for comments with Disqus. Finally we automated the deployment with [Drone](https://github.com/drone) to [Github-Pages](https://pages.github.com/). And that is not even all we had to do.

Of course with this new knowledge and experience under our belt, we would be able to start another blog in a fraction of this time.
But nevertheless the time we had to invest for this first one was substantial.

## So was it worth the effort?

After moving ...

- we can easily modify the design of the blog
- we can track everything to our heart's content
- we have a really cool team publishing workflow with Markdown, Git, Github-Pages and Drone

So yes we think it was worth it.

I guess our new blog still has some kinks we have to iron out. If you find a problem let us know!
