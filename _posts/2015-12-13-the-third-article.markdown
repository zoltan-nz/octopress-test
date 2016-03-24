---
layout: post
title: "Testing Handlebar code"
date: 2015-12-13T21:19:43+13:00
category: test
---

# Title

## Subtitle


Add a table to `app/templates/admin/invitations.hbs`

```
<!-- app/templates/admin/invitations.hbs -->

{% raw %}<h1>Invitations</h1>

<table class="table table-bordered table-striped">
    <thead>
      <tr>
          <th>ID</th>
          <th>E-mail</th>
      </tr>
    </thead>
    <tbody>
    {{#each model as |invitation|}}
        <tr>
            <th>{{invitation.id}}</th>
            <td>{{invitation.email}}</td>
        </tr>
    {{/each}}

    </tbody>
</table>{% endraw %}
```
