from invoke import task


@task
def format(c):
    """
    Run code formatters.
    """
    c.run("uv run autoflake ./tf/lambda/handler.py")
    c.run("uv run isort ./tf/lambda/handler.py")
    c.run("uv run black ./tf/lambda/handler.py")
